create extension if not exists "moddatetime" with schema "extensions";


  create table "public"."Record" (
    "mangaId" text not null,
    "pluginId" text not null,
    "userId" uuid not null,
    "datetime" timestamp with time zone not null,
    "chapterId" text,
    "chapterTitle" text,
    "page" integer not null,
    "updatedAt" timestamp with time zone not null default now()
      );


alter table "public"."Record" enable row level security;


  create table "public"."Saved" (
    "mangaId" text not null,
    "pluginId" text not null,
    "userId" uuid not null,
    "datetime" timestamp with time zone not null,
    "updates" boolean not null,
    "latestChapter" text not null,
    "updatedAt" timestamp with time zone not null default now()
      );


alter table "public"."Saved" enable row level security;

CREATE UNIQUE INDEX "Record_pkey" ON public."Record" USING btree ("mangaId", "pluginId", "userId");

CREATE UNIQUE INDEX "Saved_pkey" ON public."Saved" USING btree ("mangaId", "pluginId", "userId");

alter table "public"."Record" add constraint "Record_pkey" PRIMARY KEY using index "Record_pkey";

alter table "public"."Saved" add constraint "Saved_pkey" PRIMARY KEY using index "Saved_pkey";

alter table "public"."Record" add constraint "Record_userId_fkey" FOREIGN KEY ("userId") REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Record" validate constraint "Record_userId_fkey";

alter table "public"."Saved" add constraint "Saved_userId_fkey" FOREIGN KEY ("userId") REFERENCES auth.users(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Saved" validate constraint "Saved_userId_fkey";

grant delete on table "public"."Record" to "anon";

grant insert on table "public"."Record" to "anon";

grant references on table "public"."Record" to "anon";

grant select on table "public"."Record" to "anon";

grant trigger on table "public"."Record" to "anon";

grant truncate on table "public"."Record" to "anon";

grant update on table "public"."Record" to "anon";

grant delete on table "public"."Record" to "authenticated";

grant insert on table "public"."Record" to "authenticated";

grant references on table "public"."Record" to "authenticated";

grant select on table "public"."Record" to "authenticated";

grant trigger on table "public"."Record" to "authenticated";

grant truncate on table "public"."Record" to "authenticated";

grant update on table "public"."Record" to "authenticated";

grant delete on table "public"."Record" to "service_role";

grant insert on table "public"."Record" to "service_role";

grant references on table "public"."Record" to "service_role";

grant select on table "public"."Record" to "service_role";

grant trigger on table "public"."Record" to "service_role";

grant truncate on table "public"."Record" to "service_role";

grant update on table "public"."Record" to "service_role";

grant delete on table "public"."Saved" to "anon";

grant insert on table "public"."Saved" to "anon";

grant references on table "public"."Saved" to "anon";

grant select on table "public"."Saved" to "anon";

grant trigger on table "public"."Saved" to "anon";

grant truncate on table "public"."Saved" to "anon";

grant update on table "public"."Saved" to "anon";

grant delete on table "public"."Saved" to "authenticated";

grant insert on table "public"."Saved" to "authenticated";

grant references on table "public"."Saved" to "authenticated";

grant select on table "public"."Saved" to "authenticated";

grant trigger on table "public"."Saved" to "authenticated";

grant truncate on table "public"."Saved" to "authenticated";

grant update on table "public"."Saved" to "authenticated";

grant delete on table "public"."Saved" to "service_role";

grant insert on table "public"."Saved" to "service_role";

grant references on table "public"."Saved" to "service_role";

grant select on table "public"."Saved" to "service_role";

grant trigger on table "public"."Saved" to "service_role";

grant truncate on table "public"."Saved" to "service_role";

grant update on table "public"."Saved" to "service_role";


  create policy "Users can delete their own records"
  on "public"."Record"
  as permissive
  for delete
  to public
using (("userId" = ( SELECT auth.uid() AS uid)));



  create policy "Users can insert their own records"
  on "public"."Record"
  as permissive
  for insert
  to public
with check (("userId" = ( SELECT auth.uid() AS uid)));



  create policy "Users can update their own records"
  on "public"."Record"
  as permissive
  for update
  to public
using (("userId" = ( SELECT auth.uid() AS uid)));



  create policy "Users can view their own records"
  on "public"."Record"
  as permissive
  for select
  to public
using (("userId" = ( SELECT auth.uid() AS uid)));



  create policy "Users can delete their own saved items"
  on "public"."Saved"
  as permissive
  for delete
  to public
using (("userId" = ( SELECT auth.uid() AS uid)));



  create policy "Users can insert their own saved items"
  on "public"."Saved"
  as permissive
  for insert
  to public
with check (("userId" = ( SELECT auth.uid() AS uid)));



  create policy "Users can update their own saved items"
  on "public"."Saved"
  as permissive
  for update
  to public
using (("userId" = ( SELECT auth.uid() AS uid)));



  create policy "Users can view their own saved items"
  on "public"."Saved"
  as permissive
  for select
  to public
using (("userId" = ( SELECT auth.uid() AS uid)));


CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public."Record" FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime('updatedAt');

CREATE TRIGGER handle_updated_at BEFORE UPDATE ON public."Saved" FOR EACH ROW EXECUTE FUNCTION extensions.moddatetime('updatedAt');


