import { ApolloClient, InMemoryCache, createHttpLink } from '@apollo/client/core';
import { setContext } from '@apollo/client/link/context';
import { onError } from '@apollo/client/link/error';
import { useAuth } from '../stores/useAuth';
import { toast } from 'react-toastify';

// GRAPHQL endpoint config.
const httpLink = createHttpLink({
    uri: 'http://localhost:3000/graphql',
    credentials: 'include',
});

//Middleware to validate & add token at headers in each request.
const authLink = setContext((_, { headers }) => {
  return {
    headers: {
      ...headers,
    },
    credentials: "include",
  }
});

const csrfToken = setContext(() => {
  const token = document
  .querySelector('meta[name="csrf-token"]')
  ?.getAttribute('content');
  return {
    headers: {
      'X-CSRF-Token': token || '',
    },
  };
});

// Error handling for GraphQL requests.
const errorLink = onError(({ graphQLErrors, networkError }) => {
  if (graphQLErrors) {
    graphQLErrors.forEach(({ message, locations, path, extensions }) => {
      console.error(`[GraphQL error]: Message: ${message}, Location: ${locations}, Path: ${path}`);
      toast.error(`GraphQL error: ${message}`, { position: "top-center" });
    });
  }
  if (networkError) {
    console.error(`[Network error]: ${networkError}`);
    if ((networkError as any).statusCode === 401 || (networkError as any).response?.status === 401) {
        useAuth.getState().signOut();
        toast.error("Access not authorized or session expired. Please log in again.", { position: "top-center" });
    } else if (networkError.message.includes('Failed to fetch')) {
        toast.error("Couldn't connect to the server. Please check your internet connection.", { position: "top-center" });
    } else {
        toast.error(`Network error: ${networkError.message || "Unexpected network error."}`, { position: "top-center" });
    }
  }
});

const apolloClient = new ApolloClient({
  link: authLink.concat(csrfToken).concat(errorLink).concat(httpLink),
  cache: new InMemoryCache(),
});

export default apolloClient;