import type {ReactNode} from 'react';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import Heading from '@theme/Heading';

export default function Home(): ReactNode {
  const {siteConfig} = useDocusaurusContext();
  return (
    <Layout
      title={siteConfig.title}
      description={siteConfig.tagline}>
      <main className="container margin-vert--lg">
        <Heading as="h1">{siteConfig.title}</Heading>
        <p>{siteConfig.tagline}</p>
        <div className="margin-top--md">
          <Link className="button button--primary" to="/docs/intro">
            Read introduction
          </Link>
          <Link className="button button--secondary margin-left--sm" to="/docs/api/front">
            Frontend API
          </Link>
          <Link className="button button--secondary margin-left--sm" to="/backend-api">
            Backend API
          </Link>
        </div>
      </main>
    </Layout>
  );
}
