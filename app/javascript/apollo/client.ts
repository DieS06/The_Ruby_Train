import { ApolloClient, InMemoryCache, createHttpLink } from '@apollo/client/core';
import { setContext } from '@apollo/client/link/context';
import { onError } from '@apollo/client/link/error';
import { useAuth } from '../stores/useAuth';
import { toastAlert } from '@/bundles/components/Utils/toasts';

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
  const messages = new Set<string>();

  if (graphQLErrors?.length) {
    for (const err of graphQLErrors) {
      if (err.message) messages.add(err.message);
    }
  }

  if (networkError) {
    const msg = (networkError as any).message || "Network error.";
    messages.add(msg);

    const status = (networkError as any).statusCode || (networkError as any).response?.status;
    if (status === 401) {
      useAuth.getState().signOut();
    }
  }

  if (messages.size > 0) {
    toastAlert.error(Array.from(messages).join(". "));
  }
});

const apolloClient = new ApolloClient({
  link: authLink.concat(csrfToken).concat(errorLink).concat(httpLink),
  cache: new InMemoryCache(),
});

export default apolloClient;