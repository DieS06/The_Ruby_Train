import { toast, Id, ToastOptions } from "react-toastify";
import { useToasts } from "@/stores/useToasts";
import type { TFunction } from "i18next";
import i18n from "../../../i18n";
import "../../../styles/toasts/toasts.scss";
import SuccessIcon from "./AnimIcons/SuccessIcon";
import WarningIcon from "./AnimIcons/WarningIcon";
import ErrorIcon from "./AnimIcons/ErrorIcon";
import LoadIcon from "./AnimIcons/LoadingIcon";
import InfoIcon from "./AnimIcons/InformationIcon";
import HelpIcon from "./AnimIcons/HelpIcon";

type TranslationKey = Parameters<TFunction>[0];
type ToastFn = (key: TranslationKey, options?: ToastOptions) => Id | void;

const baseOptions: ToastOptions = {
    autoClose: 6000,
    closeOnClick: true,
    closeButton: true,
    pauseOnHover: true,
    draggable: true,
    progressClassName: "toast-progress",
    progress: undefined,
}
const fired = () => useToasts.getState().fired();
const success: ToastFn = (key, options = {}) => {
    fired();
    return toast.success(i18n.t(key), { 
        ...baseOptions, 
        autoClose: 7500,
        icon: () => <SuccessIcon/>,
        className: "toast-success",
        ...options
    });
}

const error: ToastFn = (key, options = {}) => {
    fired();
    return toast.error(i18n.t(key), {   
        ...baseOptions, 
        autoClose: 7500,
        icon: () => <ErrorIcon/>,
        className: "toast-error",
        ...options
    });
}

const info: ToastFn = (key, options = {}) => {
    fired();
    return toast.info(i18n.t(key), { 
        ...baseOptions, 
        autoClose: 7500,
        icon: () => <InfoIcon/>,
        className: "toast-info",
        progressClassName: "toast-progress-info",
        ...options
    });
}

const warn: ToastFn = (key, options = {}) => {
    fired();
    return toast.warn(i18n.t(key), { 
        ...baseOptions, 
        autoClose: 7500,
            icon: () => <WarningIcon/>,
            className: "toast-warn",
            progressClassName: "toast-progress-warn",
            ...options
    });
}

const def: ToastFn = (key, options = {}) => {
    fired();
    return toast.info(i18n.t(key), { 
        ...baseOptions, 
        autoClose: 7500,
            icon: () => <HelpIcon/>,
            className: "toast-default",
            ...options
    });
}

const loading: ToastFn = (key, options = {}) => {
    fired();
    return toast.info(i18n.t(key), { 
        ...baseOptions, 
        autoClose: 7500,
        icon: () => <LoadIcon/>,
        className: "toast-load",
        progressClassName: "toast-progress-info",
        ...options
    });
}

const dismissToast = (id: Id) => {
    if (id) toast.dismiss(id);
    else toast.dismiss();
}

export const toastAlert = { 
    success, error, 
    info, warn, def,
    load: loading, 
    dismiss: dismissToast
};