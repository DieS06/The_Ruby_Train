type RegisterData = {
    first_name: string;
    last_name: string;
    country: string;
    phone_number: string;
    email: string;
    password?: string;
    password_confirmation?: string;
};

export type { RegisterData as Register };