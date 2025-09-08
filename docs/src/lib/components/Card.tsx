import { ArrowRight } from 'lucide-react';
import Link from 'next/link';
import type React from 'react';

interface CardProps {
  title: string;
  href?: string;
  children?: React.ReactNode;
  icon?: React.ReactNode;
  className?: string;
}

export const Card: React.FC<CardProps> = ({
  title,
  href,
  children,
  icon,
  className = '',
}) => {
  const cardContent = (
    <div
      className={`
      group relative p-6 bg-white dark:bg-gray-800
      border border-gray-200 dark:border-gray-700
      rounded-xl shadow-sm hover:shadow-md
      transition-all duration-200
      hover:border-blue-200 dark:hover:border-blue-700
      ${href ? 'cursor-pointer' : ''}
      ${className}
    `}
    >
      {icon && (
        <div className="mb-4 text-blue-500 dark:text-blue-400">{icon}</div>
      )}

      <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2 group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
        {title}
        {href && (
          <ArrowRight className="inline-block w-4 h-4 ml-1 opacity-0 group-hover:opacity-100 transition-opacity" />
        )}
      </h3>

      {children && (
        <div className="text-sm text-gray-600 dark:text-gray-300 leading-relaxed">
          {children}
        </div>
      )}
    </div>
  );

  if (href) {
    return (
      <Link href={href} className="block no-underline">
        {cardContent}
      </Link>
    );
  }

  return cardContent;
};

interface CardsProps {
  children: React.ReactNode;
  className?: string;
}

export const Cards: React.FC<CardsProps> = ({ children, className = '' }) => {
  return (
    <div
      className={`
      grid gap-4 mt-6
      grid-cols-1 sm:grid-cols-2 lg:grid-cols-3
      ${className}
    `}
    >
      {children}
    </div>
  );
};
