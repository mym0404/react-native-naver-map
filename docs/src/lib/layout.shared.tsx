import type { BaseLayoutProps } from 'fumadocs-ui/layouts/shared';
import Image from 'next/image';
import { i18n } from '@/lib/i18n';

/**
 * Shared layout configurations
 *
 * you can customise layouts individually from:
 * Home Layout: app/(home)/layout.tsx
 * Docs Layout: app/docs/layout.tsx
 */
export function baseOptions(): BaseLayoutProps {
  return {
    i18n,
    nav: {
      title: (
        <>
          <div
            className={
              'w-8 h-8 rounded-full dark:bg-fd-accent  center relative p-1'
            }
          >
            <Image
              src={'/logo-180.png'}
              alt={'logo'}
              width={24}
              height={24}
              className={'animate-fd-fade-in'}
            />
          </div>
          <div className={'space-x-1'}>
            <span className={'text-xs opacity-50'}>RN</span>
            <span>Naver Map</span>
          </div>
        </>
      ),
    },
    // see https://fumadocs.dev/docs/ui/navigation/links
    links: [
      { text: 'Documentation', url: '/docs' },
      {
        text: 'Changelog',
        url: 'https://github.com/mym0404/react-native-naver-map/releases',
      },
      {
        text: 'Milestone',
        url: '/docs/milestone',
      },
      {
        text: 'Donate',
        url: 'https://github.com/sponsors/mym0404',
      },
    ],
    githubUrl: 'https://github.com/mym0404/react-native-naver-map',
    searchToggle: {
      enabled: true,
    },
  };
}
