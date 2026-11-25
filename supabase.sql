-- Execute este script no SQL Editor do seu projeto Supabase.
-- O projeto deve ser usado somente pela Pousada Beira Rio.

create table if not exists public.pousada_estado (
  id text primary key check (id = 'principal'),
  reservas jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.pousada_estado enable row level security;

-- Somente usuários autenticados podem ler ou alterar os dados.
 drop policy if exists "Acesso autenticado ao estado da pousada" on public.pousada_estado;
create policy "Acesso autenticado ao estado da pousada"
  on public.pousada_estado
  for all
  to authenticated
  using (true)
  with check (true);

-- Habilita atualizações em tempo real para os outros dispositivos.
do $$
begin
  alter publication supabase_realtime add table public.pousada_estado;
exception
  when duplicate_object then null;
end $$;
