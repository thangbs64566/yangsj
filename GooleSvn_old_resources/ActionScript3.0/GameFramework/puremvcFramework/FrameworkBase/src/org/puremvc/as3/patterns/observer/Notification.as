/*
 PureMVC - Copyright(c) 2006-08 Futurescale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
*/
package org.puremvc.as3.patterns.observer
{
	import org.puremvc.as3.interfaces.*;
	
	/**
	 * A base <code>INotification</code> implementation.
	 * 
	 * <P>
	 * PureMVC does not rely upon underlying event models such 
	 * as the one provided with Flash, and ActionScript 3 does 
	 * not have an inherent event model.</P>
	 * 
	 * <P>
	 * The Observer Pattern as implemented within PureMVC exists 
	 * to support event-driven communication between the 
	 * application and the actors of the MVC triad.</P>
	 * 
	 * <P>
	 * Notifications are not meant to be a replacement for Events
	 * in Flex/Flash/Apollo. Generally, <code>IMediator</code> implementors
	 * place event listeners on their view components, which they
	 * then handle in the usual way. This may lead to the broadcast of <code>Notification</code>s to 
	 * trigger <code>ICommand</code>s or to communicate with other <code>IMediators</code>. <code>IProxy</code> and <code>ICommand</code>
	 * instances communicate with each other and <code>IMediator</code>s 
	 * by broadcasting <code>INotification</code>s.</P>
	 * 
	 * <P>
	 * A key difference between Flash <code>Event</code>s and PureMVC 
	 * <code>Notification</code>s is that <code>Event</code>s follow the 
	 * 'Chain of Responsibility' pattern, 'bubbling' up the display hierarchy 
	 * until some parent component handles the <code>Event</code>, while
	 * PureMVC <code>Notification</code>s follow a 'Publish/Subscribe'
	 * pattern. PureMVC classes need not be related to each other in a 
	 * parent/child relationship in order to communicate with one another
	 * using <code>Notification</code>s.
	 * 
	 * @see org.puremvc.as3.patterns.observer.Observer Observer
	 * 
	 */
	public class Notification implements INotification
	{
		
		/**
		 * Constructor. 
		 * 
		 * @param name name of the <code>Notification</code> instance. (required)
		 * @param body the <code>Notification</code> body. (optional)
		 * @param type the type of the <code>Notification</code> (optional)
		 */
		public function Notification( $name:String, $body:Object=null, $type:String=null )
		{
			this._name = $name;
			this._body = $body;
			this._type = $type;
		}
		
		/**
		 * Get the name of the <code>Notification</code> instance.
		 * 
		 * @return the name of the <code>Notification</code> instance.
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * Set the body of the <code>Notification</code> instance.
		 */
		public function set body( value:Object ):void
		{
			this._body = value;
		}
		
		/**
		 * Get the body of the <code>Notification</code> instance.
		 * 
		 * @return the body object. 
		 */
		public function get body():Object
		{
			return _body;
		}
		
		/**
		 * Set the type of the <code>Notification</code> instance.
		 */
		public function set type( value:String ):void
		{
			this._type = value;
		}
		
		/**
		 * Get the type of the <code>Notification</code> instance.
		 * 
		 * @return the type  
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * Get the string representation of the <code>Notification</code> instance.
		 * 
		 * @return the string representation of the <code>Notification</code> instance.
		 */
		public function toString():String
		{
			var msg:String = "Notification Name: "+ _name;
			msg += "\nBody:"+(( _body == null )?"null":_body.toString());
			msg += "\nType:"+(( _type == null )?"null":_type);
			return msg;
		}
		
		public function dispose():void
		{
			_name = null;
			_type = null;
			_body = null;
		}
		
		// the name of the notification instance
		private var _name			: String;
		// the type of the notification instance
		private var _type			: String;
		// the body of the notification instance
		private var _body			: Object;
		
	}
}