CKEDITOR.plugins.add('test',
{
    init: function(editor)
    {
      alert('here');
        var pluginName = 'test';
        editor.addCommand(pluginName, new CKEDITOR.dialogCommand(pluginName));
        editor.ui.addButton('Footnote',
            {
                label: 'Footnote or Citation',
                command: pluginName
            });
    }
});
