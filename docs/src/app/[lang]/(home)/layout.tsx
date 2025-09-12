import { HomeLayout } from 'fumadocs-ui/layouts/home';
import type { PropsWithChildren } from 'react';
import { baseOptions } from '@/lib/layout.shared';

export default async function Layout({ children }: PropsWithChildren) {
  return <HomeLayout {...baseOptions()}>{children}</HomeLayout>;
}
