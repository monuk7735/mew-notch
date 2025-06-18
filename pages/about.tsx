import HomeContainer from "@/components/home-container";
import Head from "next/head";
import { ReactNode } from "react";

export default function About() {
  return (
    <>
      <Head>
        <title>About MewNotch</title>
      </Head>

      <div className="flex-grow flex flex-col items-center justify-center min-h-[60vh] p-8 gap-8">
        <p className="text-3xl text-blue-400 font-semibold text-center mb-4">
          100% Open Source &amp; Completely Free
        </p>
        <p className="text-lg text-gray-300 max-w-3xl px-8 py-4 text-center leading-relaxed">
          MewNotch is a macOS app designed to make the MacBook notch actually useful!
          <br />
          <br />
          It displays system information such as brightness, volume, power state, and more, right in the notch area.
          <br />
          <br />
          Built with a focus on minimalism, customization, and a seamless user experience, MewNotch is open source and inspired by the idea of turning a hardware quirk into a feature.
        </p>
      </div>
    </>
  );
}

About.getLayout = function getLayout(page: ReactNode) {
  return <HomeContainer>{page}</HomeContainer>;
};
