declare module "@rails/activestorage";

declare global {
  namespace JSX {
    interface IntrinsicElements {
      "trix-editor": React.DetailedHTMLProps<
        React.HTMLAttributes<HTMLElement>,
        HTMLElement
      > & { input?: string };
    }
  }
}

export {};