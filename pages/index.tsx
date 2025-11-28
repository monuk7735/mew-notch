import HomeContainer from "@/components/home-container";
import Link from "next/link";
import { ReactNode } from "react";
import { FaApple, FaGithub, FaArrowRight } from "react-icons/fa";
import nextConfig from "../next.config";
import Head from "next/head";

export default function Home() {
  const assetPrefix = nextConfig.basePath || "";

  return (
    <>
      <Head>
        <title>MewNotch - The Notch, Reimagined.</title>
      </Head>

      {/* Main Content Wrapper - Centered */}
      <div className="flex flex-col items-center justify-center min-h-[calc(100vh-80px)] px-6 py-12 md:py-20 gap-12 max-w-7xl mx-auto w-full">

        {/* Text Content */}
        <div className="flex flex-col items-center text-center gap-6 max-w-3xl z-10">
          {/* Badge */}
          <a
            href="https://github.com/monuk7735/mew-notch"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-blue-500/10 border border-blue-500/20 text-blue-600 dark:text-blue-400 text-sm font-medium hover:bg-blue-500/20 transition-colors mb-2"
          >
            <FaGithub /> Open Source on GitHub
          </a>

          {/* Headline */}
          <h1 className="text-5xl md:text-7xl font-bold tracking-tight text-gray-900 dark:text-white leading-tight">
            Make your Notch <br className="hidden md:block" />
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600 dark:from-blue-400 dark:to-purple-400">
              Extraordinary.
            </span>
          </h1>

          {/* Subhead */}
          <p className="text-xl text-gray-600 dark:text-gray-300 leading-relaxed max-w-2xl">
            Transform that empty space into a powerful, dynamic dashboard.
            Control media, monitor system stats, and access files instantly.
          </p>

          {/* CTAs */}
          <div className="flex flex-col sm:flex-row items-center gap-4 mt-4 w-full sm:w-auto">
            <Link
              href="https://github.com/monuk7735/mew-notch/releases"
              target="_blank"
              rel="noopener noreferrer"
              className="w-full sm:w-auto px-8 py-4 rounded-full bg-blue-600 hover:bg-blue-700 text-white font-bold text-lg shadow-lg hover:shadow-blue-500/25 transition-all duration-200 flex items-center justify-center gap-2 transform hover:-translate-y-0.5"
            >
              <FaApple className="text-2xl" />
              Download for macOS
            </Link>
            <Link
              href="/features"
              className="w-full sm:w-auto px-8 py-4 rounded-full bg-white/50 dark:bg-white/10 hover:bg-white/80 dark:hover:bg-white/20 backdrop-blur-md border border-gray-200 dark:border-white/10 text-gray-900 dark:text-white font-semibold text-lg transition-all duration-200 flex items-center justify-center gap-2 group transform hover:-translate-y-0.5"
            >
              Explore Features
              <FaArrowRight className="group-hover:translate-x-1 transition-transform" />
            </Link>
          </div>

          {/* Install Help Link */}
          <Link
            href="/faq?q=install"
            className="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white transition-colors underline decoration-dotted"
          >
            Having trouble installing?
          </Link>
        </div>

        {/* Video Preview */}
        <div className="relative w-full max-w-5xl mt-8 group perspective-1000">
          {/* Glow Effect */}
          <div className="absolute -inset-1 bg-gradient-to-r from-blue-500 to-purple-600 rounded-2xl blur opacity-20 group-hover:opacity-40 transition duration-1000 group-hover:duration-200"></div>

          <div className="relative rounded-xl md:rounded-2xl overflow-hidden shadow-2xl border border-gray-200 dark:border-gray-800 bg-gray-900 ring-1 ring-white/10">
            <video
              className="w-full h-auto"
              autoPlay
              loop
              muted
              playsInline
              aria-hidden="true"
              src={`${assetPrefix}/preview/main.mp4`}
            />
          </div>
        </div>

        {/* Support CTA */}
        <div className="mt-8 text-center animate-fade-in-up">
          <Link
            href="/support"
            className="inline-flex items-center gap-2 px-5 py-2 rounded-full bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-300 transition-colors text-sm font-medium"
          >
            <span>❤️ Support the Project</span>
          </Link>
        </div>

      </div>
    </>
  );
}

Home.getLayout = function getLayout(page: ReactNode) {
  return <HomeContainer>{page}</HomeContainer>;
};
