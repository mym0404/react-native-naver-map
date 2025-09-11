import '@/app/global.css';
import { defineI18nUI } from 'fumadocs-ui/i18n';
import { RootProvider } from 'fumadocs-ui/provider';
import { i18n } from '@/lib/i18n';

const { provider } = defineI18nUI(i18n, {
  translations: {
    ko: {
      displayName: '한국어',
      chooseTheme: '테마 선택',
      chooseLanguage: '언어 선택',
      lastUpdate: '마지막 업데이트',
      search: '검색',
      editOnGithub: '깃허브에서 수정하기',
      nextPage: '다음 페이지',
      previousPage: '이전 페이지',
      toc: '목차',
      searchNoResult: '검색결과 없음',
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
