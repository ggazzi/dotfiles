'use strict';
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';

import Window = vscode.window;
import Position = vscode.Position;
import Range = vscode.Range;
import Selection = vscode.Selection;
import TextEditor = vscode.TextEditor;

function formatTikzcd(text:string): string[] {
    const rows = text.replace(/\\arrow/g, '\\ar').split('\\\\')
    const lines:string[] = []
    for (let r = 0; r < rows.length; r++) {
        const cells = rows[r].split('&').map(c => c.replace(/^\s*/, '').replace(/\s*$/, ''))
        if (r + 1 < rows.length) {
            cells[cells.length - 1] = (cells[cells.length-1] + ' \\\\').replace(/^\s*/, '')
        }

        let line_indent = ''
        let line = line_indent
        let is_first = true
        for (const cell of cells) {
            if (is_first) {
                is_first = false
            } else {
                line += '& '
                line_indent += '  '
            }

            if (cell) {
                lines.push(line + cell)
                line = line_indent
            }
        }
    }

    return lines
}

function processSelection(e: TextEditor) {
    var replaceRanges: Selection[] = [];
    const d = e.document;
    const sel = e.selections;

    const eol = d.eol == vscode.EndOfLine.CRLF ? '\r\n' : '\n'

	e.edit(function (edit) {
		// iterate through the selections
		for (let x = 0; x < sel.length; x++) {
            const startLine = d.lineAt(sel[x].start)
            const endLine = d.lineAt(sel[x].end)
            const rng = new Range(startLine.range.start, endLine.range.end)
            const txt: string = d.getText(rng);

            //replace the txt in the current select and work out any range adjustments
            const formattedLines = formatTikzcd(txt)

            const prefix = d.lineAt(sel[x].start).text.match(/^\s*/)
            const indent = prefix? prefix[0] : ''
            edit.replace(rng, formattedLines.map(l => indent + l).join(eol));
            
			let endPos: Position = new Position(startLine.lineNumber + formattedLines.length - 1, formattedLines[formattedLines.length-1].length + indent.length);
			replaceRanges.push(new Selection(startLine.range.start, endPos));
		}
	});
	e.selections = replaceRanges;
}

// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
export function activate(context: vscode.ExtensionContext) {

    let disposable = vscode.commands.registerCommand('tikzcd-fmt.format', () => {
        const e = Window.activeTextEditor

        if (!e) {
            Window.showInformationMessage('Open a file first to manipulate text selections');
            return;
        } 

        processSelection(e);
    });

    context.subscriptions.push(disposable);
}

// this method is called when your extension is deactivated
export function deactivate() {
}