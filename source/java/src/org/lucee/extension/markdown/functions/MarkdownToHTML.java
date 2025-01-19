package org.lucee.extension.markdown.functions;

import org.commonmark.node.Node;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;

import lucee.runtime.PageContext;
import org.lucee.extension.markdown.functions.FunctionSupport;
import lucee.runtime.exp.PageException;


public class MarkdownToHTML extends FunctionSupport {

	private static final long serialVersionUID = 3775127934350736736L;

	public Object invoke(PageContext pc, Object[] args) throws PageException {
		if (args.length < 1 || args.length > 2) {
			throw exp.createExpressionException("MarkdownToHTML requires between 1 and 3 arguments [string, safemode, encoding], but [" 
				+ args.length + " ] provided");
		}
		return call(pc, cast.toString(args[0]));
	}

	public static String call(PageContext pc, String markdown) {
		return call(pc, markdown, false, null);
	}

	public static String call(PageContext pc, String markdown, boolean safeMode) {
		return call(pc, markdown, safeMode, null);
	}

	public static String call(PageContext pc, String markdown, boolean safeMode, String encoding) {
		Parser parser = Parser.builder().build();
		// Parse the markdown to a Node
		Node document = parser.parse(markdown);
		// Create a HTML renderer
		HtmlRenderer renderer = HtmlRenderer.builder().build();
		// Render the Node to HTML
		return renderer.render(document);
	}

	/*
	 * public static void main(String[] args) { print.e(Processor.process("This is ***TXTMARK***",
	 * false)); }
	 */
}