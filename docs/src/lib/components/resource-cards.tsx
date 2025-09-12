import Link from 'next/link';

interface ResourceCard {
  title: string;
  description: string;
  href: string;
  isExternal?: boolean;
}

interface ResourceCardsProps {
  lang: string;
  title?: string;
  cards?: ResourceCard[];
}

const defaultCards: ResourceCard[] = [
  {
    title: 'Documentation',
    description: 'Complete API reference and guides',
    href: '/docs',
    isExternal: false,
  },
  {
    title: 'Milestone',
    description: 'The next purpose of ours',
    href: '/docs/milestone',
    isExternal: false,
  },
  {
    title: 'iOS SDK',
    description: 'Native iOS documentation',
    href: 'https://navermaps.github.io/ios-map-sdk/guide-ko/',
    isExternal: true,
  },
  {
    title: 'Android SDK',
    description: 'Native Android documentation',
    href: 'https://navermaps.github.io/android-map-sdk/guide-ko/',
    isExternal: true,
  },
];

export const ResourceCards = ({
  lang,
  title = 'Explore More',
  cards = defaultCards,
}: ResourceCardsProps) => {
  return (
    <section className="px-6 py-16">
      <div className="mx-auto max-w-6xl">
        <h2 className="mb-12 text-center text-3xl font-bold">{title}</h2>
        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
          {cards.map((card) => {
            const href = card.isExternal ? card.href : `/${lang}${card.href}`;
            const className =
              'group rounded-lg border border-fd-border bg-fd-card p-6 transition-all hover:border-fd-primary/50 hover:bg-fd-muted/50';

            const cardContent = (
              <>
                <h3 className="font-semibold group-hover:text-fd-primary">
                  {card.title}
                </h3>
                <p className="text-sm text-fd-muted-foreground">
                  {card.description}
                </p>
              </>
            );

            return card.isExternal ? (
              <a
                key={card.title}
                href={href}
                target="_blank"
                rel="noopener noreferrer"
                className={className}
              >
                {cardContent}
              </a>
            ) : (
              <Link key={card.title} href={href} className={className}>
                {cardContent}
              </Link>
            );
          })}
        </div>
      </div>
    </section>
  );
};
