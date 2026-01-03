import { themes as prismThemes } from 'prism-react-renderer';
import type { Config } from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: 'MedAI Docs',
  tagline: 'Clinical text analysis and entity extraction platform',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  // GitHub Pages deployment
  url: 'https://Herreran903.github.io',
  baseUrl: '/docs-medai/',
  trailingSlash: false,

  organizationName: 'Herreran903',
  projectName: 'docs-medai',

  onBrokenLinks: 'throw',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          editUrl: 'https://github.com/Herreran903/docs-medai/tree/main/',
        },
        blog: {
          showReadingTime: true,
          editUrl: 'https://github.com/Herreran903/docs-medai/tree/main/',
          onInlineTags: 'warn',
          onInlineAuthors: 'warn',
          onUntruncatedBlogPosts: 'warn',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/medai-social-card.jpg',

    colorMode: {
      respectPrefersColorScheme: true,
    },

    navbar: {
      title: 'MedAI',
      logo: {
        alt: 'MedAI Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'tutorialSidebar',
          position: 'left',
          label: 'Overview',
        },
        {
          type: 'docSidebar',
          sidebarId: 'frontApi',
          position: 'left',
          label: 'Frontend API',
        },
        {
          type: 'doc',
          docId: 'api/back/index',
          position: 'left',
          label: 'Backend API',
        },
        {
          to: '/blog',
          label: 'Updates',
          position: 'left',
        },
        {
          href: 'https://github.com/Herreran903/medai-frontend',
          label: 'Frontend',
          position: 'right',
        },
        {
          href: 'https://github.com/Herreran903/medai-backend',
          label: 'Backend',
          position: 'right',
        },
      ],
    },

    footer: {
      style: 'dark',
      links: [
        {
          title: 'MedAI',
          items: [
            {
              label: 'Platform Overview',
              to: '/docs/intro',
            },
            {
              label: 'Clinical Use Cases',
              to: '/docs/use-cases',
            },
          ],
        },
        {
          title: 'APIs',
          items: [
            {
              label: 'Frontend API',
              to: '/docs/api/front',
            },
            {
              label: 'Backend API',
              to: '/docs/api/back',
            },
          ],
        },
        {
          title: 'Development',
          items: [
            {
              label: 'Docs Repository',
              href: 'https://github.com/Herreran903/docs-medai',
            },
            {
              label: 'Issues',
              href: 'https://github.com/Herreran903/docs-medai/issues',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} MedAI. Clinical NLP & AI Platform.`,
    },

    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
