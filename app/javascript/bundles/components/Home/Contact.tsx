import React, { useState } from "react";
import api from "@/services/Axios/axios";
import { useTranslation } from "react-i18next";
import { Input } from "../Accesible_Assets/Input";
import { TextArea } from "../Accesible_Assets/TextArea";
import { SubmitButton } from "../Accesible_Assets/SubmitButton";
import { toastAlert } from "../Utils/toasts";
import image from "../../../assets/imgs/TRT_Contact.png";
import "@/styles/components/Home/Contact.scss";

const ContactForm: React.FC = () => {
  const { t } = useTranslation("home");
  const [form, setForm] = useState({
    name: "", email: "", subject: "", message: ""
  });
  const [loading, setLoading] = useState(false);

  const onChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setForm(s => ({ ...s, [name]: value }));
  };

  const validate = () => {
    if (!form.name.trim() || !form.email.trim() || !form.message.trim()) {
      toastAlert.info(t("contact.validations.required"));
      return false;
    }
    const emailOk = /\S+@\S+\.\S+/.test(form.email);
    if (!emailOk) {
      toastAlert.info(t("contact.validations.email"));
      return false;
    }
    if (form.message.length > 1000) {
      toastAlert.info(t("contact.validations.max"));
      return false;
    }
    return true;
  };

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;
    setLoading(true);
    try {
      await api.post(
        "/contact_messages",
        { contact_message: form },
        { headers: 
          { 
            Accept: "application/json",
            "Content-Type": "application/json"
          }
        }
      );
      toastAlert.success(t("contact.success"));
      setForm({ name: "", email: "", subject: "", message: "" });
    } catch (err: any) {
      const msg = err?.response?.data?.error || err?.message || t("contact.error");
      toastAlert.error(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <section className="contact-form-section">
        <h2 className="contact-form-title">{t("contact.title")}</h2>
        <form className="contact-form" onSubmit={onSubmit}>
            <Input name="name"    placeholder={t("contact.placeholders.name")}  value={form.name}    onChange={onChange} />
            <Input name="email"   placeholder={t("contact.placeholders.email")} value={form.email}   onChange={onChange} type="email" />
            <Input name="subject" placeholder={t("contact.placeholders.subject")} value={form.subject} onChange={onChange} />

            <TextArea
                name="message"
                label={t("contact.placeholders.msg-title")}
                value={form.message}
                onChange={onChange}
                maxLength={1000}
                showCount
                placeholder={t("contact.placeholders.message")}
            />

            <SubmitButton isLogicallyDisabled={loading}>
                {loading ? "..." : t("contact.send")}
            </SubmitButton>
        </form>
        {/* <article className="contact-form-visuals">
          <img src={image} alt="Contact visuals" className="contact-image" />
        </article> */}
    </section>
  );
};

export default ContactForm;