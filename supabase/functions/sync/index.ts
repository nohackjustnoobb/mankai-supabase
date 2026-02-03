import "@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "@supabase/supabase-js";
import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import { sql } from "drizzle-orm";
import { records, saveds } from "./schema.ts";

const connectionString = Deno.env.get("DB_CONNECTION_STRING")!;
const client = postgres(connectionString, { prepare: false });
const db = drizzle(client);

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  try {
    // 1. Authenticate user
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: { "Content-Type": "application/json" },
      });
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      { global: { headers: { Authorization: authHeader } } },
    );

    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: { "Content-Type": "application/json" },
      });
    }

    const userId = user.id;

    // 2. Parse body
    const body = await req.json();
    const recordsToSync = Array.isArray(body.records) ? body.records : [];
    const savedsToSync = Array.isArray(body.saveds) ? body.saveds : [];

    // 3. Upsert Records
    if (recordsToSync.length > 0) {
      const validRecords = recordsToSync
        .filter(
          // deno-lint-ignore no-explicit-any
          (r: any) =>
            r.mangaId && r.pluginId && r.datetime && r.page !== undefined,
        )
        // deno-lint-ignore no-explicit-any
        .map((r: any) => ({
          userId,
          mangaId: r.mangaId,
          pluginId: r.pluginId,
          datetime: new Date(r.datetime),
          chapterId: r.chapterId,
          chapterTitle: r.chapterTitle,
          page: r.page,
        }));

      if (validRecords.length > 0) {
        await db
          .insert(records)
          .values(validRecords)
          .onConflictDoUpdate({
            target: [records.mangaId, records.pluginId, records.userId],
            set: {
              datetime: sql`excluded."datetime"`,
              chapterId: sql`excluded."chapterId"`,
              chapterTitle: sql`excluded."chapterTitle"`,
              page: sql`excluded."page"`,
            },
            where: sql`${records.datetime} < excluded."datetime"`,
          });
      }
    }

    // 4. Upsert Saveds
    if (savedsToSync.length > 0) {
      const validSaveds = savedsToSync
        .filter(
          // deno-lint-ignore no-explicit-any
          (s: any) =>
            s.mangaId &&
            s.pluginId &&
            s.datetime &&
            s.updates !== undefined &&
            s.latestChapter !== undefined,
        )
        // deno-lint-ignore no-explicit-any
        .map((s: any) => ({
          userId,
          mangaId: s.mangaId,
          pluginId: s.pluginId,
          datetime: new Date(s.datetime),
          updates: s.updates,
          latestChapter: s.latestChapter,
          isDeleted: false,
        }));

      if (validSaveds.length > 0) {
        await db
          .insert(saveds)
          .values(validSaveds)
          .onConflictDoUpdate({
            target: [saveds.mangaId, saveds.pluginId, saveds.userId],
            set: {
              datetime: sql`excluded."datetime"`,
              updates: sql`excluded."updates"`,
              latestChapter: sql`excluded."latestChapter"`,
              isDeleted: sql`excluded."isDeleted"`,
            },
            where: sql`${saveds.datetime} < excluded."datetime"`,
          });
      }
    }

    return new Response(JSON.stringify({ success: true }), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error(error);
    return new Response(JSON.stringify({ error: "Failed to sync" }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }
});
