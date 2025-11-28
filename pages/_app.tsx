import "@/styles/globals.css";
import { ThemeProvider } from "next-themes";
import { ReactNode } from "react";
import type { AppProps } from "next/app";

type AppLayoutProps = AppProps & {
  Component: AppProps["Component"] & {
    getLayout?: (page: ReactNode) => ReactNode;
  };
};

export default function App({ Component, pageProps }: AppLayoutProps) {

  const getLayout = Component.getLayout || ((page: ReactNode) => page);

  return (
    <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
      {getLayout(<Component {...pageProps} />)}
    </ThemeProvider>
  );
}