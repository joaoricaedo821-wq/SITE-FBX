-- Execute este SQL no SQL Editor do seu projeto Supabase.
create table if not exists public.matches (
  id uuid primary key default gen_random_uuid(),
  home_team text not null,
  away_team text not null,
  match_date date,
  match_time text,
  competition text,
  stream_url text not null,
  status text not null default 'EM BREVE'
    check (status in ('EM BREVE','AO VIVO','ENCERRADO')),
  home_logo text,
  away_logo text,
  created_at timestamptz not null default now()
);

alter table public.matches enable row level security;

-- Visitantes podem ver a programação.
drop policy if exists "Public can read matches" on public.matches;
create policy "Public can read matches"
on public.matches for select
to anon, authenticated
using (true);

-- Somente usuários autenticados podem cadastrar/editar/excluir.
drop policy if exists "Admins can insert matches" on public.matches;
create policy "Admins can insert matches"
on public.matches for insert
to authenticated
with check (auth.uid() is not null);

drop policy if exists "Admins can update matches" on public.matches;
create policy "Admins can update matches"
on public.matches for update
to authenticated
using (auth.uid() is not null)
with check (auth.uid() is not null);

drop policy if exists "Admins can delete matches" on public.matches;
create policy "Admins can delete matches"
on public.matches for delete
to authenticated
using (auth.uid() is not null);
