# Mankai Supabase

This project manages the database schema for Mankai.

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

### 5. Configure Authentication

1.  Go to the Supabase Dashboard for your project.
2.  Navigate to **Authentication** > **Providers**.
3.  Enable and configure the desired OAuth providers (Only OAuth providers are supported).
4.  If you encounter issues with the login callback:
    - Navigate to **Authentication** > **URL Configuration**.
    - Set the **Site URL** to `mankai://login-callback`.
