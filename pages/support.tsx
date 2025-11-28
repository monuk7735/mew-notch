import HomeContainer from "@/components/home-container";
import { ReactNode } from "react";
import Head from "next/head";
import { FaCoffee, FaHeart, FaStar } from "react-icons/fa";

export default function Support() {
  return (
    <>
      <Head>
        <title>Support - MewNotch</title>
      </Head>
      <div className="flex flex-col items-center justify-center min-h-[70vh] px-6 py-20 max-w-3xl mx-auto w-full text-center">

        <div className="w-20 h-20 bg-red-100 dark:bg-red-900/30 rounded-full flex items-center justify-center text-red-500 dark:text-red-400 text-4xl mb-8 animate-pulse" aria-hidden="true">
          <FaHeart />
        </div>

        <h1 className="text-4xl md:text-5xl font-bold text-gray-900 dark:text-white mb-6">
          Support MewNotch
        </h1>

        <p className="text-xl text-gray-600 dark:text-gray-300 leading-relaxed mb-12">
          MewNotch is a labor of love, developed in my free time.
          It is and always will be free to use.
          <br /><br />
          However, if you find it useful and want to support its continued development,
          you can buy me a coffee. It&apos;s completely optional, but highly appreciated!
        </p>

        <div className="flex flex-col sm:flex-row gap-4 justify-center w-full max-w-md">
          <a
            href="https://www.buymeacoffee.com/monuk7735"
            target="_blank"
            rel="noopener noreferrer"
            className="group flex items-center justify-center gap-3 px-8 py-4 rounded-xl bg-[#FFDD00] text-black font-bold text-lg shadow-lg hover:shadow-xl hover:scale-105 transition-all duration-200"
          >
            <FaCoffee className="text-xl" />
            <span>Buy me a coffee</span>
          </a>

          <a
            href="https://github.com/monuk7735/mew-notch"
            target="_blank"
            rel="noopener noreferrer"
            className="group flex items-center justify-center gap-3 px-8 py-4 rounded-xl bg-gray-900 dark:bg-gray-800 text-white font-bold text-lg shadow-lg hover:shadow-xl hover:scale-105 transition-all duration-200 border border-gray-700"
          >
            <FaStar className="text-yellow-400 group-hover:rotate-360 transition-transform duration-500" />
            <span>Star on GitHub</span>
          </a>
        </div>

        <p className="mt-12 text-sm text-gray-600 dark:text-gray-400">
          Even a simple star on GitHub helps the project grow! 🌟
        </p>

      </div>
    </>
  );
}

Support.getLayout = function getLayout(page: ReactNode) {
  return <HomeContainer>{page}</HomeContainer>;
};
