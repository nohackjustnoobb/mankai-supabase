-- Create Record table
CREATE TABLE "Record" (
    "mangaId" text NOT NULL,
    "pluginId" text NOT NULL,
    "userId" uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    "datetime" timestamp WITH time zone NOT NULL,
    "chapterId" text,
    "chapterTitle" text,
    "page" integer NOT NULL,
    "updatedAt" timestamp WITH time zone NOT NULL DEFAULT NOW(),
    CONSTRAINT "Record_pkey" PRIMARY KEY ("mangaId", "pluginId", "userId")
);

-- Enable RLS for Record
ALTER TABLE
    "Record" enable ROW LEVEL SECURITY;

-- Policies for Record
CREATE policy "Users can view their own records" ON "Record" FOR
SELECT
    USING (
        "userId" = (
            SELECT
                auth.uid()
        )
    );

CREATE policy "Users can insert their own records" ON "Record" FOR
INSERT
    WITH CHECK (
        "userId" = (
            SELECT
                auth.uid()
        )
    );

CREATE policy "Users can update their own records" ON "Record" FOR
UPDATE
    USING (
        "userId" = (
            SELECT
                auth.uid()
        )
    );

CREATE policy "Users can delete their own records" ON "Record" FOR DELETE USING (
    "userId" = (
        SELECT
            auth.uid()
    )
);

-- Create Saved table
CREATE TABLE "Saved" (
    "mangaId" text NOT NULL,
    "pluginId" text NOT NULL,
    "userId" uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    "datetime" timestamp WITH time zone NOT NULL,
    "updates" boolean NOT NULL,
    "latestChapter" text NOT NULL,
    "updatedAt" timestamp WITH time zone NOT NULL DEFAULT NOW(),
    CONSTRAINT "Saved_pkey" PRIMARY KEY ("mangaId", "pluginId", "userId")
);

-- Enable RLS for Saved
ALTER TABLE
    "Saved" enable ROW LEVEL SECURITY;

-- Policies for Saved
CREATE policy "Users can view their own saved items" ON "Saved" FOR
SELECT
    USING (
        "userId" = (
            SELECT
                auth.uid()
        )
    );

CREATE policy "Users can insert their own saved items" ON "Saved" FOR
INSERT
    WITH CHECK (
        "userId" = (
            SELECT
                auth.uid()
        )
    );

CREATE policy "Users can update their own saved items" ON "Saved" FOR
UPDATE
    USING (
        "userId" = (
            SELECT
                auth.uid()
        )
    );

CREATE policy "Users can delete their own saved items" ON "Saved" FOR DELETE USING (
    "userId" = (
        SELECT
            auth.uid()
    )
);

-- Enable moddatetime extension if not already enabled
CREATE extension IF NOT EXISTS moddatetime schema extensions;

-- Function to handle updatedAt updates (using moddatetime extension)
CREATE trigger handle_updated_at before
UPDATE
    ON "Record" FOR each ROW EXECUTE PROCEDURE moddatetime ("updatedAt");

CREATE trigger handle_updated_at before
UPDATE
    ON "Saved" FOR each ROW EXECUTE PROCEDURE moddatetime ("updatedAt");