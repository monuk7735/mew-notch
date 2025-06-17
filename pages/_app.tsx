import "@/styles/globals.css";
import { ReactNode } from "react";
import type { AppProps } from "next/app";

type AppLayoutProps = AppProps & {
  Component: AppProps["Component"] & {
    getLayout?: (page: ReactNode) => ReactNode;
  };
};

export default function App({ Component, pageProps }: AppLayoutProps) {

  const getLayout = Component.getLayout || ((page: ReactNode) => page);

  return getLayout(<Component {...pageProps} />);
}