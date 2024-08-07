import { constants } from '../../src/constants.js';
import { sayHello } from '../../src/hello-world.js';

describe('hello-world unit tests', () => {
  describe('sayHello()', () => {
    it('should return "Hello World!"', () => {
      expect(sayHello()).toBe(constants.HELLO_WORLD);
    });
  });
});
