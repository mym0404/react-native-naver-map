import { DynamicCodeBlock } from 'fumadocs-ui/components/dynamic-codeblock';

interface TerminalCodeBlockProps {
  code: string;
  lang?: string;
  filename?: string;
  variant?: 'install' | 'code';
}

export function TerminalCodeBlock({
  code,
  lang = 'bash',
  filename,
  variant = 'code',
}: TerminalCodeBlockProps) {
  const gradientClass =
    variant === 'install'
      ? 'from-green-500/5 via-transparent to-blue-500/5'
      : 'from-purple-500/5 via-transparent to-pink-500/5';

  return (
    <div className="relative overflow-hidden rounded-xl bg-gradient-to-b from-zinc-900 to-zinc-950 shadow-2xl border border-zinc-800">
      <div
        className={`absolute inset-0 bg-gradient-to-tr ${gradientClass} pointer-events-none`}
      />

      <div className="flex items-center gap-2 border-b border-zinc-800 bg-black/50 px-4 py-3">
        <div className="flex gap-1.5">
          <div className="h-3 w-3 rounded-full bg-red-500" />
          <div className="h-3 w-3 rounded-full bg-yellow-500" />
          <div className="h-3 w-3 rounded-full bg-green-500" />
        </div>
        {filename && (
          <span className="text-xs font-mono text-zinc-400 ml-2">
            {filename}
          </span>
        )}
      </div>

      <DynamicCodeBlock
        codeblock={{
          keepBackground: false,
        }}
        lang={lang}
        code={code}
      />
    </div>
  );
}
