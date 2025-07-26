declare module "@hotwired/turbo" {
  export function visit(url: string, options?: { action?: "advance" | "replace" | "restore" }): void;
}