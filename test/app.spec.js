var expect = require("chai").expect;
var request = require('supertest');
process.env.NODE_ENV = 'test';

var app = require('../app.js');

describe("Routing", () => {
  describe("web", () => {
    it("GET /web returns server", (done) => {
      request(app)
        .get('/web')
        .expect(200, 'server', done);
    });
  });
});