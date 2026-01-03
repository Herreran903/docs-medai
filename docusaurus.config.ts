import { themes as prismThemes } from 'prism-react-renderer';
import type { Config } from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: 'MedAI Docs',
  tagline: 'Documentacion de la plataforma de extraccion de entidades clinicas',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  // GitHub Pages deployment
  url: 'https://herreran903.github.io',
  baseUrl: '/docs-medai/',
  trailingSlash: false,

  organizationName: 'Herreran903',
  projectName: 'docs-medai',

  onBrokenLinks: 'warn',
  onBrokenMarkdownLinks: 'warn',

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
        blog: false,
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/logo.svg',

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
          type: 'docSidebar',
          sidebarId: 'backendApi',
          position: 'left',
          label: 'Backend API',
        },
        {
          href: 'https://medai-frontend-seven.vercel.app/',
          label: 'App',
          position: 'right',
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
        {
          href: 'https://github.com/Herreran903/docs-medai',
          label: 'Docs',
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
              to: '/docs/backend-api',
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
