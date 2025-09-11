import '@/app/global.css';
import { defineI18nUI } from 'fumadocs-ui/i18n';
import { RootProvider } from 'fumadocs-ui/provider';
import type { Metadata } from 'next';
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

export const metadata: Metadata = {
  title: {
    template: '%s | React Native Naver Map',
    default: 'React Native Naver Map',
  },
  description:
    'Native-performance map component with seamless Naver SDK integration, complete TypeScript support, and easy-to-use API designed for React Native developers.',
  keywords: [
    'React Native',
    'Naver Map',
    'Maps',
    'Mobile Development',
    'iOS',
    'Android',
    'TypeScript',
    'Navigation',
    'Location',
  ],
  authors: [{ name: 'MJ Studio', url: 'https://mjstudio.net' }],
  creator: 'MJ Studio',
  openGraph: {
    title: 'React Native Naver Map',
    description:
      'Native-performance map component with seamless Naver SDK integration, complete TypeScript support, and easy-to-use API designed for React Native developers.',
    url: 'https://rnnavermap.mjstudio.net',
    siteName: 'React Native Naver Map',
    locale: 'ko_KR',
    type: 'website',
    images: [
      {
        url: '/social-image.png',
        width: 1200,
        height: 675,
        alt: 'React Native Naver Map',
      },
    ],
  },
  twitter: {
    card: 'summary',
    title: 'React Native Naver Map',
    description:
      'Native-performance map component with seamless Naver SDK integration, complete TypeScript support, and easy-to-use API designed for React Native developers.',
    images: ['/social-image.png'],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
};

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
