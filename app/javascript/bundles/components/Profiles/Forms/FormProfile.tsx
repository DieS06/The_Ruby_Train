import React, { useState } from "react";
import { useMutation } from "@apollo/client";
import { UPDATE_PROFILE_MUTATION } from "@/apollo/mutations/user/updateProfile";
import { MY_PROFILE_QUERY } from "@/apollo/queries/user/myProfile";
import type { UserProfile } from "@/types/Profile/UserInformation";
import { Input } from "../../Accesible_Assets/Input";
import { TextArea } from "../../Accesible_Assets/TextArea";
import { SubmitButton } from "../../Accesible_Assets/SubmitButton";
import { toastAlert } from "@/bundles/components/Utils/toasts";
import "../../../../styles/components/Profile/Forms/FormProfile.scss";

interface Props { profile: UserProfile }

const FormProfile: React.FC<Props> = ({ profile }) => {
    const [form, setForm] = useState({
    bio:          profile.bio || "",
    linkedin_url: profile.linkedinUrl || "",
    github_url:   profile.githubUrl || "",
    website_url:  profile.websiteUrl || "",
    location:     profile.location || "",
    company_name: profile.companyName || "",
    job_title:    profile.jobTitle || "",
  });

  const isUnchanged = () => {
    const a = form;
    const b = {
      bio:          profile.bio || "",
      linkedin_url: profile.linkedinUrl || "",
      github_url:   profile.githubUrl || "",
      website_url:  profile.websiteUrl || "",
      location:     profile.location || "",
      company_name: profile.companyName || "",
      job_title:    profile.jobTitle || "",
    };
    return Object.keys(b).every((k) => String((a as any)[k] ?? "").trim() === String((b as any)[k] ?? "").trim());
  };

  const [updateProfile, { loading }] = useMutation(UPDATE_PROFILE_MUTATION, {
        onCompleted: ({ updateProfile }) => {
          if (updateProfile?.errors?.length) {
            toastAlert.error([...new Set(updateProfile.errors)].join(". "));
          } else {
            toastAlert.success("Profile updated");
          }
        },
        refetchQueries: [{ query: MY_PROFILE_QUERY }],
        awaitRefetchQueries: true,
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (isUnchanged()) {
      toastAlert.info("No changes detected");
      return;
    }

    try {
      await updateProfile({ variables: { ...form } });
    } catch (error) {
      console.error(error);
    }
  };

  const updatedAt = profile.updatedAt ? new Date(profile.updatedAt) : null;

  return (
    <form onSubmit={handleSubmit} className="profile-form">
      <article className="updated-at-data">
        <p> Last update at: </p>
        <p> {updatedAt ? updatedAt.toLocaleDateString() : "-"}</p>
        {/* <p> {updatedAt ? updatedAt.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit", hour12: true }) : "-"}</p> */}
      </article>

      <TextArea 
        name="bio"
        label="Biography"
        value={form.bio} onChange={function (e: React.ChangeEvent<HTMLTextAreaElement>): void {
          setForm((prev) => ({ ...prev, bio: e.target.value }));
        }}
        maxLength={500}
        showCount
      />

      <article className="job-company">
        <Input 
        name="job_title"
        label="Job title"
        value={form.job_title}
        onChange={handleChange}
        />

        <Input 
        name="company_name"
        label="Company"
        value={form.company_name} 
        onChange={handleChange} 
        />
      </article>
      
      <Input 
      name="location"
      label="Location"
      value={form.location}
      onChange={handleChange}
      />

      <article className="social-links">
        <p className="social-label" >Social Media Links</p>
        <Input 
        name="linkedin_url"
        value={form.linkedin_url} 
        onChange={handleChange} 
        placeholder="LinkedIn URL" />

        <Input 
        name="github_url"
        value={form.github_url}   
        onChange={handleChange} 
        placeholder="GitHub URL" />

        <Input 
        name="website_url"
        value={form.website_url}
        onChange={handleChange} 
        placeholder="Website URL" />
      </article>
      
      <div className="form-actions">
        <SubmitButton 
          isLogicallyDisabled={loading}>
            Save
        </SubmitButton>
      </div>
    </form>
  );
}

export default FormProfile; 