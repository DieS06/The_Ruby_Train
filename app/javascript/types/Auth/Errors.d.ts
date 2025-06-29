type BackendErrorsResponse = {
    errors?: { [key: string]: string | string[] };
    error?: string;
    message?: string;
}

type RegisterResponse = {
    message?: string;
}

export type { BackendErrorsResponse as BEErrors, RegisterResponse };