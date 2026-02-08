import type {ReactNode} from 'react';
import {useState} from 'react';
import Layout from '@theme/Layout';
import {RedocStandalone} from 'redoc';
import useBaseUrl from '@docusaurus/useBaseUrl';
import styles from './index.module.css';

export default function BackendApi(): ReactNode {
  const specs = [
    {id: 'gateway', label: 'Gateway', path: '/openapi/gateway.json'},
    {id: 'ner-transformer', label: 'NER Transformer', path: '/openapi/ner-transformer.json'},
    {id: 'ner-bilstm', label: 'NER BiLSTM', path: '/openapi/ner-bilstm.json'},
    {id: 'ner-llm', label: 'NER LLM', path: '/openapi/ner-llm.json'},
  ];
  const [activeId, setActiveId] = useState(specs[0].id);
  const activeSpec = specs.find((spec) => spec.id === activeId) ?? specs[0];

  return (
    <Layout title="Backend API" description="Backend API reference">
      <main className={styles.main}>
        <div className={styles.header}>
          <div className={styles.heading}>OpenAPI por servicio</div>
          <div className={styles.subheading}>Selecciona el servicio para ver su especificación.</div>
        </div>
        <div className={styles.selector}>
          {specs.map((spec) => (
            <button
              key={spec.id}
              className={spec.id === activeId ? styles.tabActive : styles.tab}
              onClick={() => setActiveId(spec.id)}
              type="button"
            >
              {spec.label}
            </button>
          ))}
        </div>
        <div className={styles.redocContainer}>
          <RedocStandalone
            key={activeSpec.id}
            specUrl={useBaseUrl(activeSpec.path)}
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
