import '@/app/global.css';
import { defineI18nUI } from 'fumadocs-ui/i18n';
import { RootProvider } from 'fumadocs-ui/provider';
import { i18n } from '@/lib/i18n';

const { provider } = defineI18nUI(i18n, {
  translations: {
    ko: {
      displayName: '한국어',
    },
    en: {
      displayName: 'English',
    },
  },
});

export default async function Layout({
  children,
  params,
}: LayoutProps<'/[lang]'>) {
  const lang = (await params).lang;
  return (
    <html lang={lang} suppressHydrationWarning>
      <body className="flex flex-col min-h-screen">
        <RootProvider i18n={provider(lang)}>{children}</RootProvider>
      </body>
    </html>
  );
}
