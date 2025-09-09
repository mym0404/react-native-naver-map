import { Head } from 'nextra/components';
import { getPageMap } from 'nextra/page-map';
import { Footer, Layout, Navbar } from 'nextra-theme-docs';
import 'nextra-theme-docs/style.css';
import type { ReactNode } from 'react';
import './globals.css';
import type { Metadata } from 'next';
import Image from 'next/image';
import Script from 'next/script';

export const metadata: Metadata = {
  title: 'Naver Map React Native',
  description:
    'React Native library for Naver Maps with native implementations for iOS and Android',
  openGraph: {
    images: 'https://rnnavermap.mjstudio.net/social-image.png',
  },
  twitter: {
    images: 'https://rnnavermap.mjstudio.net/social-image.png',
  },
};

const navbar = (
  <Navbar
    logo={
      <div className={'row-center gap-2'}>
        <Image src={'/logo.png'} alt={'logo'} width={32} height={32} />
        <p className={'flex-col flex'}>
          <span className={'text-xs font-medium opacity-40'}>React Native</span>
          <span className={'font-bold'}>Naver Map</span>
        </p>
      </div>
    }
    logoLink={'/'}
    projectLink={'https://github.com/mym0404/react-native-naver-map'}
  />
);

const footer = <Footer>MIT {new Date().getFullYear()} © MJ Studio.</Footer>;

export default async function RootLayout({
  children,
}: {
  children: ReactNode;
}) {
  return (
    <html
      // Not required, but good for SEO
      lang="ko"
      // Required to be set
      dir="ltr"
      // Suggested by `next-themes` package https://github.com/pacocoursey/next-themes#with-app
      suppressHydrationWarning
    >
      <Script
        defer
        src={'https://umami.mjstudio.net/script.js'}
        data-website-id={'20802a8b-5591-4919-a8af-d20317718fd0'}
      />
      <Head
        color={{
          hue: { light: 160, dark: 164 }, // 0~360
          saturation: 80, // 0~100 (단일값 또는 light/dark 분리 가능)
          lightness: { light: 44, dark: 60 }, // 0~100
        }}
        backgroundColor={{
          dark: '#080808',
        }}
        // ... Your additional head options
      >
        {/* Your additional tags should be passed as `children` of `<Head>` element */}
      </Head>
      <body>
        <Layout
          navbar={navbar}
          pageMap={await getPageMap()}
          docsRepositoryBase="https://github.com/mym0404/react-native-naver-map/tree/main/docs"
          footer={footer}
        >
          {children}
        </Layout>
      </body>
    </html>
  );
}
