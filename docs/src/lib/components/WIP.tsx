import { GhostIcon } from 'lucide-react';

type WIPProps = {};
const WIP = ({}: WIPProps) => {
  return (
    <div
      className={
        'col-center gap-2 self-center  py-8  border-b border-neutral-500'
      }
    >
      <div
        className={'p-2 bg-neutral-100 dark:bg-neutral-900 rounded-full center'}
      >
        <GhostIcon className={'animate-pulse'} />
      </div>
      <span className={'font-medium text-sm'}>Working In Progress</span>
    </div>
  );
};

export { WIP };
export type { WIPProps };
