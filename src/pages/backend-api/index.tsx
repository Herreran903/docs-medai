import type {ReactNode} from 'react';
import Layout from '@theme/Layout';
import {RedocStandalone} from 'redoc';
import useBaseUrl from '@docusaurus/useBaseUrl';
import styles from './index.module.css';

export default function BackendApi(): ReactNode {
  return (
    <Layout title="Backend API" description="Backend API reference">
      <main className={styles.main}>
        <div className={styles.redocContainer}>
          <RedocStandalone
            specUrl={useBaseUrl('/openapi/backend.json')}
            options={{
              scrollYOffset: 'nav',
              hideDownloadButton: false,
            }}
          />
        </div>
      </main>
    </Layout>
  );
}
