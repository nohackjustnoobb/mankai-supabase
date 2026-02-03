import {
  pgTable,
  text,
  uuid,
  timestamp,
  integer,
  boolean,
  primaryKey,
} from "drizzle-orm/pg-core";

export const records = pgTable(
  "Record",
  {
    mangaId: text("mangaId").notNull(),
    pluginId: text("pluginId").notNull(),
    userId: uuid("userId").notNull(),
    datetime: timestamp("datetime", { withTimezone: true }).notNull(),
    chapterId: text("chapterId"),
    chapterTitle: text("chapterTitle"),
    page: integer("page").notNull(),
    updatedAt: timestamp("updatedAt", { withTimezone: true }).notNull(),
  },
  (table) => {
    return {
      pk: primaryKey({
        columns: [table.mangaId, table.pluginId, table.userId],
      }),
    };
  },
);

export const saveds = pgTable(
  "Saved",
  {
    mangaId: text("mangaId").notNull(),
    pluginId: text("pluginId").notNull(),
    userId: uuid("userId").notNull(),
    datetime: timestamp("datetime", { withTimezone: true }).notNull(),
    updates: boolean("updates").notNull(),
    latestChapter: text("latestChapter").notNull(),
    isDeleted: boolean("isDeleted").notNull().default(false),
    updatedAt: timestamp("updatedAt", { withTimezone: true }).notNull(),
  },
  (table) => {
    return {
      pk: primaryKey({
        columns: [table.mangaId, table.pluginId, table.userId],
      }),
    };
  },
);
