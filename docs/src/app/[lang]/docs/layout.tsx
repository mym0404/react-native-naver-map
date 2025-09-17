import { DocsLayout } from 'fumadocs-ui/layouts/docs';
import type { PropsWithChildren } from 'react';
import { baseOptions } from '@/lib/layout.shared';
import { source } from '@/lib/source';

export default async function Layout({
  children,
  params,
}: PropsWithChildren<{ params: Promise<{ lang: string }> }>) {
  const { lang } = await params;
  return (
    <DocsLayout
      tree={source.pageTree[lang]}
      {...baseOptions({ lang })}
      links={[]}
    >
      {children}
    </DocsLayout>
  );
}
