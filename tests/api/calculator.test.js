const supertest = require("supertest");
const { expect } = require("chai");
// const assert = require('assert');
const app = require("../../src/server");

describe('Hello API Request', () => {
    it('should return response on call', (done) => {
        supertest(app).get('/').then(res => {
            expect(res.body.message).to.be.equal('App is up and running!!!');
            return done();
        }).catch((err) => {
            return done(err);
        });
    });
    it('should return response on call', (done) => {
        supertest(app).get('/add').then(res => {
            expect(200);
            expect(res.body.data).to.be.equal(7);
            return done();
        }).catch((err) => {
            return done(err);
        });
    });
    it('should return response on call', (done) => {
        supertest(app).get('/subtract').then(res => {
            expect(res.body.data).to.be.equal(-3);
            expect(200);
            return done();
        }).catch((err) => {
            return done(err);
        });
    });
});