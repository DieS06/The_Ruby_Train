export class CustomAuthError extends Error {
  public errors: string[];
  constructor(message: string, errors: string[]) {
    super(message);
    this.name = "CustomAuthError";
    this.errors = errors;
  }
}