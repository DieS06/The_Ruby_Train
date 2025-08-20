export interface UserRole {
    id: number;
    name: string;
    resource_type?: string | null;
    resource_id?: number | null;
    created_at?: string;
    updated_at?: string;
}

export interface UserInformation {
    id: number;
    email: string;
    first_name: string;
    last_name: string;
    country: string;
    phone_number: string;
    state: string;
    
    role: UserRoleProps[];

    created_at: string;
    updated_at: string;

    provider?: string | null;
    uid?: string | null;
}

export interface UserProfile {
    id: number;
    bio: string | null;
    linkedinUrl: string | null;
    githubUrl: string | null;
    websiteUrl: string | null;
    location: string | null;
    companyName?: string | null;
    jobTitle?: string | null;

    user: UserInformation;

    createdAt?: string;
    updatedAt?: string;
}

export type { UserRole, UserInformation, UserProfile};