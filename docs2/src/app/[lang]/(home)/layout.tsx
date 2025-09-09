import { HomeLayout } from 'fumadocs-ui/layouts/home';
import { baseOptions } from '@/lib/layout.shared';

export default async function Layout({ children }: LayoutProps<'/[lang]'>) {
  return <HomeLayout {...baseOptions()}>{children}</HomeLayout>;
}
