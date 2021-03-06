package why.email;

import why.Email;
import #if haxe4 js.lib.Error #else js.Error #end as JsError;

using tink.CoreApi;

/**
 * AWS SES
 * Requires the `aws-sdk` node module
 */
@:build(futurize.Futurize.build())
@:require('futurize')
class AwsSes implements Email {
	var ses:SES;
	
	public function new(?config) {
		ses = new SES(config);
	}
	
	public function send(config:EmailConfig):Promise<Noise> {
		return @:futurize ses.sendEmail({
			Source: config.from.toString(),
			Destination: {
				ToAddresses: config.to == null ? null : [for(a in config.to) a.toString()],
				BccAddresses: config.bcc == null ? null : [for(a in config.bcc) a.toString()],
				CcAddresses: config.cc == null ? null : [for(a in config.cc) a.toString()],
			},
			Message: {
				Subject: {
					Data: config.subject,
				},
				Body: {
					Html: {
						Data: config.content.html,
					},
					Text: {
						Data: config.content.text,
					},
				}
			},
		}, $cb1);
	}
}


@:jsRequire('aws-sdk', 'SES')
private extern class SES {
	function new(?opt:{});
	function sendEmail(opt:{}, cb:JsError->Dynamic->Void):Void;
}