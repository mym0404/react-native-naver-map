import {
  ArrowRight,
  Code2,
  GithubIcon,
  Layers,
  MapPin,
  Package,
  StarIcon,
} from 'lucide-react';
import Image from 'next/image';
import Link from 'next/link';
import { TerminalCodeBlock } from '@/components/terminal-codeblock';

const getStarCount = async (): Promise<number | undefined> => {
  try {
    const response = await fetch(
      'https://api.github.com/repos/mym0404/react-native-naver-map',
      {
        headers: {
          Accept: 'application/vnd.github.v3+json',
          'User-Agent': 'NaverMap-Docs',
        },
        next: {
          revalidate: 3600, // 1 hour cache
        },
      }
    );

    if (!response.ok) {
      throw new Error(`GitHub API responded with ${response.status}`);
    }

    const data = await response.json();
    return data.stargazers_count;
  } catch {}
};

const quickStartCode = `import { NaverMapView } from '@mj-studio/react-native-naver-map';

export default function App() {
  return (
    <NaverMapView
      style={{ flex: 1 }}
      initialRegion={{
        latitude: 37.5665,
        longitude: 126.9780,
        latitudeDelta: 0.01,
        longitudeDelta: 0.01,
      }}
    />
  );
}`;

export default async function HomePage({
  params,
}: {
  params: Promise<{ lang: string }>;
}) {
  const { lang } = await params;
  const starCount = await getStarCount();

  return (
    <main className="flex min-h-[calc(100vh-3.5rem)] flex-col">
      {/* Hero Section */}
      <section className="relative flex flex-col items-center justify-center px-6 py-32 text-center">
        <div className="absolute inset-0 -z-10">
          <div className="absolute inset-0 bg-gradient-to-b from-green-500/10 via-transparent to-transparent" />
          <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_center,_var(--tw-gradient-stops))] from-green-500/20 via-transparent to-transparent" />
        </div>

        <Image
          alt="logo"
          src="/logo.png"
          width={200}
          height={200}
          className="relative z-10 drop-shadow-xl transition-transform duration-300 hover:scale-105 drop-shadow-orange-400 dark:drop-shadow-blue-400"
        />

        <h1 className="mb-6 text-5xl font-bold tracking-tight md:text-6xl lg:text-7xl">
          <span className="bg-gradient-to-r from-green-600 to-green-500 bg-clip-text text-transparent">
            Naver Map
          </span>
          <span className="block mt-2 text-2xl text-fd-muted-foreground md:text-3xl lg:text-4xl font-normal">
            for React Native
          </span>
        </h1>

        <p className="mb-10 max-w-3xl text-lg text-fd-muted-foreground md:text-xl leading-relaxed">
          Map component with seamless Naver SDK integration, complete TypeScript
          support, and easy-to-use API designed for{' '}
          <span className="font-semibold text-fd-foreground">React Native</span>
        </p>

        <div className="flex flex-col gap-4 sm:flex-row">
          <Link
            href={`/${lang}/docs`}
            className="inline-flex justify-center items-center gap-2 rounded-lg bg-gradient-to-r from-green-600 to-green-500 px-8 py-3.5 font-medium text-white shadow-lg transition-all hover:shadow-xl hover:scale-105"
          >
            Get Started
            <ArrowRight className="h-4 w-4" />
          </Link>
          <a
            href="https://github.com/mj-studio-library/react-native-naver-map"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 rounded-lg border border-fd-border bg-fd-background px-8 py-3.5 font-medium transition-all hover:bg-fd-muted hover:scale-105"
          >
            Star on GitHub
            <StarIcon size={14} />
            {starCount && starCount > 0 ? starCount.toLocaleString() : ''}
          </a>
        </div>
      </section>

      {/* Features Section */}
      <section className="px-6 py-16">
        <div className="mx-auto max-w-6xl">
          <h2 className="mb-12 text-center text-3xl font-bold">
            Why Choose This Library?
          </h2>

          <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
            <div className="group relative overflow-hidden rounded-xl border border-green-500/20 bg-gradient-to-br from-green-500/5 to-transparent p-6 transition-all hover:border-green-500/40 hover:shadow-lg hover:shadow-green-500/10">
              <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-green-500/10">
                <Layers className="h-6 w-6 text-green-500" />
              </div>
              <h3 className="mb-2 text-lg font-semibold">
                Native SDK Features
              </h3>
              <p className="text-sm text-fd-muted-foreground">
                Seamless access to all Naver Maps SDK capabilities with React
                Native friendly APIs
              </p>
            </div>
            <div className="group relative overflow-hidden rounded-xl border border-green-500/20 bg-gradient-to-br from-green-500/5 to-transparent p-6 transition-all hover:border-green-500/40 hover:shadow-lg hover:shadow-green-500/10">
              <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-green-500/10">
                <MapPin className="h-6 w-6 text-green-500" />
              </div>
              <h3 className="mb-2 text-lg font-semibold">
                Various Marker Types
              </h3>
              <p className="text-sm text-fd-muted-foreground">
                Support for basic symbols, local assets, native resources, web
                images, and custom React components
              </p>
            </div>
            <div className="group relative overflow-hidden rounded-xl border border-green-500/20 bg-gradient-to-br from-green-500/5 to-transparent p-6 transition-all hover:border-green-500/40 hover:shadow-lg hover:shadow-green-500/10">
              <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-green-500/10">
                <Code2 className="h-6 w-6 text-green-500" />
              </div>
              <h3 className="mb-2 text-lg font-semibold">TypeScript First</h3>
              <p className="text-sm text-fd-muted-foreground">
                Complete type definitions with codegen for type-safe
                interactions
              </p>
            </div>
            <div className="group relative overflow-hidden rounded-xl border border-green-500/20 bg-gradient-to-br from-green-500/5 to-transparent p-6 transition-all hover:border-green-500/40 hover:shadow-lg hover:shadow-green-500/10">
              <div className="mb-4 flex h-12 w-12 items-center justify-center rounded-lg bg-green-500/10">
                <Package className="h-6 w-6 text-green-500" />
              </div>
              <h3 className="mb-2 text-lg font-semibold">Easy to Go</h3>
              <p className="text-sm text-fd-muted-foreground">
                Simple setup with Expo config plugin and intuitive React-like
                API
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Quick Start Section */}
      <section className="bg-fd-muted/30 px-6 py-16">
        <div className="mx-auto max-w-4xl">
          <h2 className="mb-8 text-center text-3xl font-bold">Quick Start</h2>

          <div className="space-y-8">
            <h3 className="text-center mb-4 text-lg font-semibold">
              Install the package
            </h3>
            <TerminalCodeBlock
              code={`npm install @mj-studio/react-native-naver-map\n\n# pod install, add expo plugin, etc`}
              lang={'bash'}
              variant="install"
            />

            <h3 className="mb-4 text-lg font-semibold text-center">
              Use in your app
            </h3>
            <TerminalCodeBlock
              code={quickStartCode}
              lang="tsx"
              filename="App.tsx"
              variant="code"
            />
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="border-y border-fd-border bg-fd-muted/30 px-6 py-12">
        <div className="mx-auto max-w-6xl">
          <div className="grid gap-8 text-center md:grid-cols-4">
            <div>
              <div className="text-3xl font-bold text-green-500">100+</div>
              <div className="mt-1 text-sm text-fd-muted-foreground">
                Used by Open Source Projects
              </div>
            </div>
            <div>
              <div className="text-3xl font-bold text-green-500">50,000+</div>
              <div className="mt-1 text-sm text-fd-muted-foreground">
                Installations
              </div>
            </div>
            <div>
              <div className="text-3xl font-bold text-green-500">100%</div>
              <div className="mt-1 text-sm text-fd-muted-foreground">
                TypeScript
              </div>
            </div>
            <div>
              <div className="text-3xl font-bold text-green-500">100%</div>
              <div className="mt-1 text-sm text-fd-muted-foreground">
                Open Sources
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Resources Section */}
      <section className="px-6 py-16">
        <div className="mx-auto max-w-6xl">
          <h2 className="mb-12 text-center text-3xl font-bold">Explore More</h2>
          <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4">
            <Link
              href={`/${lang}/docs`}
              className="group rounded-lg border border-fd-border bg-fd-card p-6 transition-all hover:border-fd-primary/50 hover:bg-fd-muted/50"
            >
              <h3 className="font-semibold group-hover:text-fd-primary">
                Documentation
              </h3>
              <p className="text-sm text-fd-muted-foreground">
                Complete API reference and guides
              </p>
            </Link>
            <Link
              href={`/${lang}/docs/examples`}
              className="group rounded-lg border border-fd-border bg-fd-card p-6 transition-all hover:border-fd-primary/50 hover:bg-fd-muted/50"
            >
              <h3 className="font-semibold group-hover:text-fd-primary">
                Examples
              </h3>
              <p className="text-sm text-fd-muted-foreground">
                Sample implementations and demos
              </p>
            </Link>
            <a
              href="https://navermaps.github.io/ios-map-sdk/guide-ko/"
              target="_blank"
              rel="noopener noreferrer"
              className="group rounded-lg border border-fd-border bg-fd-card p-6 transition-all hover:border-fd-primary/50 hover:bg-fd-muted/50"
            >
              <h3 className="font-semibold group-hover:text-fd-primary">
                iOS SDK
              </h3>
              <p className="text-sm text-fd-muted-foreground">
                Native iOS documentation
              </p>
            </a>
            <a
              href="https://navermaps.github.io/android-map-sdk/guide-ko/"
              target="_blank"
              rel="noopener noreferrer"
              className="group rounded-lg border border-fd-border bg-fd-card p-6 transition-all hover:border-fd-primary/50 hover:bg-fd-muted/50"
            >
              <h3 className="font-semibold group-hover:text-fd-primary">
                Android SDK
              </h3>
              <p className="text-sm text-fd-muted-foreground">
                Native Android documentation
              </p>
            </a>
          </div>
        </div>
      </section>
    </main>
  );
}
