import React from "react";
import "@/styles/components/Home/Whatsapp.scss";

function getWhats() {
  const meta = document.querySelector('meta[name="whatsapp-number"]') as HTMLMetaElement | null;
  return meta?.content || "";
}

const WhatsAppBubble: React.FC = () => {
  const phone = getWhats();
  if (!phone) return null;

  const url = `https://wa.me/${phone}?text=${encodeURIComponent("Hello, I have a question about The Ruby Train.")}`;

  return (
    <a href={url} className="whatsapp-fab" target="_blank" rel="noopener noreferrer" aria-label="WhatsApp">
      <svg viewBox="0 0 32 32" width="26" height="26" aria-hidden="true">
        <path fill="currentColor" d="M19.11 17.2c-.27-.14-1.6-.8-1.85-.89-.25-.09-.43-.14-.61.14-.18.27-.7.89-.86 1.08-.16.18-.32.2-.59.07-.27-.14-1.15-.42-2.2-1.34-.81-.72-1.36-1.6-1.52-1.86-.16-.27-.02-.41.12-.54.12-.12.27-.32.41-.48.14-.16.18-.27.27-.45.09-.18.05-.34-.02-.48-.07-.14-.61-1.47-.83-2.01-.22-.54-.45-.47-.61-.47-.16 0-.34-.02-.52-.02s-.48.07-.73.34c-.25.27-.95.93-.95 2.26 0 1.33.97 2.62 1.1 2.8.14.18 1.9 2.9 4.6 4.06 1.61.7 2.24.76 3.04.64.49-.08 1.6-.65 1.82-1.28.22-.63.22-1.17.16-1.28-.05-.11-.2-.16-.47-.29zM16.02 3C9.39 3 4 8.39 4 15.02c0 2.123.55 4.113 1.52 5.854L4 29l8.28-1.467c1.679.918 3.605 1.442 5.64 1.442 6.63 0 12.02-5.39 12.02-12.02C29.94 8.39 23.55 3 16.92 3h-.9z"/>
      </svg>
    </a>
  );
};

export default WhatsAppBubble;