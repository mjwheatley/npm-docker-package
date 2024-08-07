import { constants } from '../../src/constants.js';
import { handler } from '../../src/lambda.js';

import type { APIGatewayProxyResult } from 'aws-lambda';

describe('lambda unit tests', () => {
  describe('handler()', () => {
    it('should return a 200 status code', async () => {
      const now = new Date().toISOString();
      const event = {
        requestContext: {
          time: now,
        },
      };
      // @ts-expect-error ignore context and callback arguments
      const result: APIGatewayProxyResult = await handler(event);

      expect(result.statusCode).toBe(200);
      const body = JSON.parse(result.body);

      expect(body.message).toBe(constants.HELLO_WORLD)
    });
  });
});
