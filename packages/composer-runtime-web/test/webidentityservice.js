/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

'use strict';

const IdentityService = require('composer-runtime').IdentityService;
const WebIdentityService = require('..').WebIdentityService;

const should = require('chai').should();
const sinon = require('sinon');

describe('WebIdentityService', () => {

    let identityService;
    let sandbox;

    beforeEach(() => {
        identityService = new WebIdentityService();
        sandbox = sinon.sandbox.create();
    });

    afterEach(() => {
        sandbox.restore();
    });

    describe('#constructor', () => {

        it('should create a identity service', () => {
            identityService.should.be.an.instanceOf(IdentityService);
        });

    });

    describe('#getCurrentUserID', () => {

        it('should return null', () => {
            should.equal(identityService.getCurrentUserID(), null);
        });

    });

});
