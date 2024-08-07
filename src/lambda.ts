import { sayHello } from './hello-world.js';

import type { APIGatewayProxyEventV2, APIGatewayProxyHandlerV2, APIGatewayProxyResult } from 'aws-lambda';

export const handler: APIGatewayProxyHandlerV2 = async (
  event: APIGatewayProxyEventV2,
): Promise<APIGatewayProxyResult> => {
  console.log('handler v2 event', { event });

  return {
    statusCode: 200,
    headers: { 'Content-Type': 'application:json' },
    body: JSON.stringify({
      message: sayHello(),
    }),
  };
};
