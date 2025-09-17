import { HomeLayout } from 'fumadocs-ui/layouts/home';
import type { PropsWithChildren } from 'react';
import { baseOptions } from '@/lib/layout.shared';

export default async function Layout({
  params,
  children,
}: PropsWithChildren<{ params: Promise<{ lang: string }> }>) {
  const { lang } = await params;
  return <HomeLayout {...baseOptions({ lang })}>{children}</HomeLayout>;
}
