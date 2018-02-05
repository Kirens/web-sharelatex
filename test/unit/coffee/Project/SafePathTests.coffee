chai = require('chai')
assert = require('chai').assert
should = chai.should()
expect = chai.expect
sinon = require 'sinon'
modulePath = "../../../../app/js/Features/Project/SafePath"
SandboxedModule = require('sandboxed-module')

describe 'SafePath', ->
	beforeEach ->
		@SafePath = SandboxedModule.require modulePath

	describe 'isCleanFilename', ->
		it 'should accept a valid filename "main.tex"', ->
			result = @SafePath.isCleanFilename 'main.tex'
			result.should.equal true

		it 'should not accept an empty filename', ->
			result = @SafePath.isCleanFilename ''
			result.should.equal false

		it 'should not accept / anywhere', ->
			result = @SafePath.isCleanFilename 'foo/bar'
			result.should.equal false

		it 'should not accept .', ->
			result = @SafePath.isCleanFilename '.'
			result.should.equal false

		it 'should not accept ..', ->
			result = @SafePath.isCleanFilename '..'
			result.should.equal false

		it 'should not accept * anywhere', ->
			result = @SafePath.isCleanFilename 'foo*bar'
			result.should.equal false

		it 'should not accept leading whitespace', ->
			result = @SafePath.isCleanFilename ' foobar.tex'
			result.should.equal false

		it 'should not accept trailing whitespace', ->
			result = @SafePath.isCleanFilename 'foobar.tex '
			result.should.equal false

		it 'should not accept leading and trailing whitespace', ->
			result = @SafePath.isCleanFilename ' foobar.tex '
			result.should.equal false

		it 'should not accept control characters (0-31)', ->
			result = @SafePath.isCleanFilename 'foo\u0010bar'
			result.should.equal false

		it 'should not accept control characters (127, delete)', ->
			result = @SafePath.isCleanFilename 'foo\u007fbar'
			result.should.equal false

		it 'should not accept control characters (128-159)', ->
			result = @SafePath.isCleanFilename 'foo\u0080\u0090bar'
			result.should.equal false

		it 'should not accept surrogate characters (128-159)', ->
			result = @SafePath.isCleanFilename 'foo\uD800\uDFFFbar'
			result.should.equal false



		# it 'should not accept a trailing .', ->
		# 	result = @SafePath.isCleanFilename 'hello.'
		# 	result.should.equal false


		# it 'should not accept \\', ->
		# 	result = @SafePath.isCleanFilename 'foo\\bar'
		# 	result.should.equal false

	describe 'isAllowedLength', ->
		it 'should accept a valid path "main.tex"', ->
			result = @SafePath.isAllowedLength 'main.tex'
			result.should.equal true

		it 'should not accept an extremely long path', ->
			longPath =  new Array(1000).join("/subdir") + '/main.tex'
			result = @SafePath.isAllowedLength longPath
			result.should.equal false

		it 'should not accept an empty path', ->
			result = @SafePath.isAllowedLength ''
			result.should.equal false
