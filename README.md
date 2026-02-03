# Mankai Supabase

This project manages the database schema for [mankai](https://github.com/nohackjustnoobb/mankai).

## Setup Instructions

### 1. Install Dependencies

Install the project dependencies, including the Supabase CLI:

```bash
yarn install
```

### 2. Login to Supabase

If you haven't already logged in to the Supabase CLI, run:

```bash
yarn supabase login
```

### 3. Link Project

Link this local project to your remote Supabase project using your Project Reference ID:

```bash
yarn supabase link --project-ref <your-project-ref>
```

You can find your Project Reference ID in the Supabase Dashboard under Project Settings > General.

### 4. Push Database Changes

To push the local migration files to the remote database:

```bash
yarn supabase db push
```

### 5. Deploy Functions

To deploy the edge functions to the remote project:

```bash
yarn supabase functions deploy
```

After deploying, set the `DB_CONNECTION_STRING` secret using the **transaction pooler connection string** (available from the **"Connect"** button in the Supabase Dashboard). Do not use the direct connection URL (`SUPABASE_DB_URL`), as it may cause connection errors.

```bash
yarn supabase secrets set DB_CONNECTION_STRING="your-transaction-pooler-connection-string"
```

### 6. Configure Authentication

1.  Go to the Supabase Dashboard for your project.
2.  Navigate to **Authentication** > **Providers**.
3.  Enable and configure the desired OAuth providers (Only OAuth providers are supported).
4.  If you encounter issues with the login callback:
    - Navigate to **Authentication** > **URL Configuration**.
    - Set the **Site URL** to `mankai://login-callback`.
