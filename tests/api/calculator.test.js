const supertest = require("supertest");
const app = require("../../src/server");

(async () => {
    const chai = await import('chai');
    const { expect } = chai;
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
            supertest(app).get('/add/3/4').then(res => {
                expect(200);
                expect(res.body.data).to.be.equal(7);
                return done();
            }).catch((err) => {
                return done(err);
            });
        });
        it('should return response on call', (done) => {
            supertest(app).get('/subtract/6/9').then(res => {
                expect(res.body.data).to.be.equal(-3);
                expect(200);
                return done();
            }).catch((err) => {
                return done(err);
            });
        });
        it('should return response on call', (done) => {
            supertest(app).get('/multiply/6/9').then(res => {
                expect(res.body.data).to.be.equal(54);
                expect(200);
                return done();
            }).catch((err) => {
                return done(err);
            });
        });
    });
})();
